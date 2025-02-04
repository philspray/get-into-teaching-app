shared_context "with stubbed types api" do
  let(:git_api_endpoint) { ENV["GIT_API_ENDPOINT"] }
  let(:stub_types) { [{ "id" => 1, "value" => "First type" }] }

  before do
    stub_request(:get, "#{git_api_endpoint}/api/pick_list_items/teaching_event/types")
      .to_return \
        status: 200,
        headers: { "Content-type" => "application/json" },
        body: stub_types.to_json

    stub_request(:get, "#{git_api_endpoint}/api/pick_list_items/qualification/degree_status")
      .to_return \
        status: 200,
        headers: { "Content-type" => "application/json" },
        body: OptionSet::DEGREE_STATUSES.map { |k, v| { id: v, value: k } }.to_json

    stub_request(:get, "#{git_api_endpoint}/api/pick_list_items/candidate/consideration_journey_stages")
      .to_return \
        status: 200,
        headers: { "Content-type" => "application/json" },
        body: OptionSet::CONSIDERATION_JOURNEY_STAGES.map { |k, v| { id: v, value: k } }.to_json

    stub_request(:get, "#{git_api_endpoint}/api/pick_list_items/teaching_event/types")
      .to_return \
        status: 200,
        headers: { "Content-type" => "application/json" },
        body: EventType::ALL.map { |k, v| { id: v, value: k } }.to_json

    stub_request(:get, "#{git_api_endpoint}/api/lookup_items/teaching_subjects")
      .to_return \
        status: 200,
        headers: { "Content-type" => "application/json" },
        body: TeachingSubject::ALL.map { |k, v| { id: v, value: k } }.to_json
  end
end

shared_context "with stubbed candidate create access token api" do
  let(:git_api_endpoint) { ENV["GIT_API_ENDPOINT"] }

  before do
    stub_request(:post, "#{git_api_endpoint}/api/candidates/access_tokens").to_return(status: 200, body: "", headers: {})
  end
end

shared_context "with stubbed latest privacy policy api" do
  let(:git_api_endpoint) { ENV["GIT_API_ENDPOINT"] }
  let(:policy) { [{ "id" => "abc123" }] }

  before do
    stub_request(:get, "#{git_api_endpoint}/api/privacy_policies/latest").to_return(status: 200, body: policy.to_json, headers: {})
  end
end

shared_context "with stubbed event add attendee api" do
  let(:git_api_endpoint) { ENV["GIT_API_ENDPOINT"] }

  before do
    stub_request(:post, "#{git_api_endpoint}/api/teaching_events/attendees").to_return(status: 200, body: "", headers: {})
  end
end

shared_context "with stubbed mailing list add member api" do
  let(:git_api_endpoint) { ENV["GIT_API_ENDPOINT"] }

  before do
    stub_request(:post, "#{git_api_endpoint}/api/mailing_list/members").to_return(status: 200, body: "", headers: {})
  end
end

shared_context "with stubbed book callback api" do
  let(:git_api_endpoint) { ENV["GIT_API_ENDPOINT"] }

  before do
    stub_request(:post, "#{git_api_endpoint}/api/get_into_teaching/callbacks").to_return(status: 200, body: "", headers: {})
  end
end
