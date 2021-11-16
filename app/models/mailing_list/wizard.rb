require "attribute_filter"

module MailingList
  class Wizard < ::DFEWizard::Base
    include ::Wizard::ApiClientSupport

    ATTRIBUTES_TO_LEAVE = %w[
      first_name
      last_name
      preferred_teaching_subject_id
      consideration_journey_stage_id
      degree_status_id
    ].freeze

    self.steps = [
      Steps::Name,
      ::DFEWizard::Steps::Authenticate,
      Steps::AlreadySubscribed,
      Steps::DegreeStatus,
      Steps::TeacherTraining,
      Steps::Subject,
      Steps::Postcode,
      Steps::PrivacyPolicy,
    ].freeze

    def matchback_attributes
      %i[candidate_id qualification_id].freeze
    end

    def complete!
      super.tap do |result|
        break unless result

        add_member_to_mailing_list

        # we're taking the last name too so if people restart the wizard
        # both are filled rather than just their first name, which looks
        # a bit odd
        @store.prune!({ leave: ATTRIBUTES_TO_LEAVE })
      end
    end

    def exchange_access_token(timed_one_time_password, request)
      @api ||= GetIntoTeachingApiClient::MailingListApi.new
      response = @api.exchange_access_token_for_mailing_list_add_member(timed_one_time_password, request)
      Rails.logger.info("MailingList::Wizard#exchange_access_token: #{AttributeFilter.filtered_json(response)}")
      response
    end

  protected

    def exchange_magic_link_token(token)
      api = GetIntoTeachingApiClient::MailingListApi.new
      response = api.exchange_magic_link_token_for_mailing_list_add_member(token)
      Rails.logger.info("MailingList::Wizard#exchange_magic_link_token: #{AttributeFilter.filtered_json(response)}")
      response
    end

  private

    def add_member_to_mailing_list
      request = GetIntoTeachingApiClient::MailingListAddMember.new(construct_export)
      api = GetIntoTeachingApiClient::MailingListApi.new
      Rails.logger.info("MailingList::Wizard#add_mailing_list_member: #{AttributeFilter.filtered_json(request)}")
      api.add_mailing_list_member(request)
    end

    def construct_export
      export = export_camelized_hash

      show_welcome_guide = ApplicationController.helpers.show_welcome_guide?(
        export[:degreeStatusId],
        export[:preferredTeachingSubjectId],
      )

      return export unless show_welcome_guide

      export.tap do |h|
        h[:welcomeGuideVariant] = export_data.slice(
          "degree_status_id",
          "preferred_teaching_subject_id",
        ).to_query
      end
    end
  end
end
