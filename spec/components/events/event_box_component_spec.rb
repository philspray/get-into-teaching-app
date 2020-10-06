require "rails_helper"

describe Events::EventBoxComponent, type: "component" do
  include_context "stub types api"
  let(:event) { build(:event_api) }

  subject! { render_inline(Events::EventBoxComponent.new(event)) }

  specify "renders an event box" do
    expect(page).to have_css(".event-box")
  end

  specify "places the date and time in the datetime div" do
    page.find(".event-box__datetime") do |datetime_div|
      expect(datetime_div).to have_content(event.start_at.to_date.to_formatted_s(:long_ordinal))
      expect(datetime_div).to have_content(event.start_at.to_formatted_s(:time))
      expect(datetime_div).to have_content(event.end_at.to_formatted_s(:time))
    end
  end

  specify "places the description in the content div" do
    page.find(".event-box__content") do |content_div|
      expect(content_div).to have_content(event.summary)
    end
  end

  describe "online/offline" do
    let(:online_heading) { "Online Event" }
    context "when the event is online" do
      let(:event) { build(:event_api, is_online: true) }

      specify %(it's marked as being online) do
        expect(page).to have_css("h5", text: online_heading)
      end
    end

    context "when the event is offline" do
      let(:event) { build(:event_api, is_online: false) }

      specify %(it's not marked as being online) do
        expect(page).not_to have_css("h5", text: online_heading)
      end
    end
  end

  describe "location" do
    context "when the event has a location" do
      specify "the city should be displayed" do
        expect(page).to have_css(".event-box__content__location")
        expect(page).to have_css("p", text: event.building.address_city)
      end
    end

    context "when the event has no location" do
      let(:event) { build(:event_api, :no_location) }

      specify "no location information should be displayed" do
        expect(page).not_to have_css(".event-box__content__location")
      end
    end
  end

  [
    OpenStruct.new(
      name: "Application Workshop",
      trait: :application_workshop,
      expected_colour: "yellow",
      is_online: false,
    ),
    OpenStruct.new(
      name: "Train to Teach Event",
      trait: :train_to_teach_event,
      expected_colour: "green",
      is_online: false,
    ),
    OpenStruct.new(
      name: "Online Event",
      trait: :online_event,
      expected_colour: "purple",
      is_online: true,
    ),
    OpenStruct.new(
      name: "",
      trait: :no_event_type,
      expected_colour: "blue",
      is_online: false,
    ),
    # a 'Train to Teach Event' that also happens to be online
    OpenStruct.new(
      name: "Train to Teach Event",
      trait: :train_to_teach_event,
      expected_colour: "green",
      is_online: true,
    ),
  ].each do |event_type|
    description = event_type.name.present? ? %(is a '#{event_type.name}') : %(isn't specified)

    context %(when the event #{description}) do
      let(:event) { build(:event_api, event_type.trait, is_online: event_type.is_online) }

      specify %(the event type name should be displayed) do
        expect(page).to have_content(event_type.name)
      end

      if event_type.is_online && event_type.trait != :online_event
        specify %(the event should also be described as an 'Online Event') do
          expect(page).to have_content("Online Event")
        end
      end

      specify %(the box should have the right type of divider) do
        if event_type.name.present?
          expect(page).to have_css(%(.event-box__divider.event-box__divider--#{event_type.name&.parameterize}))
        end
      end

      if event_type.is_online
        specify %(the online icon should be #{event_type.expected_colour}) do
          expect(page).to have_css(%(.icon-online-event--#{event_type.expected_colour}))
        end
      end

      specify %(the map pin icon should be #{event_type.expected_colour}) do
        expect(page).to have_css(%(.icon-pin--#{event_type.expected_colour}))
      end
    end
  end
end
