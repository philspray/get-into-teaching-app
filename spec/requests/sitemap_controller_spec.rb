require "rails_helper"

RSpec.describe SitemapController, type: :request do
  subject { Nokogiri::XML(response.body) }

  let(:content_pages) do
    {
      "/train-to-be-a-teacher" => {
        name: "Train to be a teacher",
        priority: 0.8,
        date: "2020-11-11",
      },
      "/salaries-and-benfits" => {
        name: "Salaries and benefits",
        priority: 0.7,
      },
      "/my-story-into-teaching/what-a-great-story" => {
        name: "What a great story",
        priority: 0.7,
        date: "2020-10-10",
      },
      "/test/a" => {
        name: "A/B Test",
        noindex: true,
      },
    }
  end
  let(:event_pages) do
    events.map { |e| event_path(e.readable_id) }.index_with({})
  end
  let(:all_sitemap_pages) { content_sitemap_pages.merge(event_pages) }
  let(:content_sitemap_pages) { content_pages.except("/test/a") }
  let(:events) { build_list(:event_api, 3) }

  before do
    freeze_time
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:search_teaching_events).with(
        start_after: Time.zone.now,
        quantity: 100,
        type_ids: [EventType.get_into_teaching_event_id, EventType.online_event_id],
      ).and_return(events)
    allow(Pages::Frontmatter).to receive(:list) { content_pages }
    get("/sitemap.xml")
  end

  describe "#show" do
    let(:sitemap_namespace) { "http://www.sitemaps.org/schemas/sitemap/0.9" }

    specify "the document should have the correct namespace" do
      expect(subject.at_xpath("/xmlns:urlset").namespace.href).to eql(sitemap_namespace)
    end

    describe "sitemap pages" do
      let(:expected) { SitemapController::OTHER_PATHS.count + all_sitemap_pages.count }
      let(:paths) { all_sitemap_pages.keys.concat(SitemapController::OTHER_PATHS) }

      specify "should have the right number of pages" do
        expect(expected).to eql(subject.xpath("/xmlns:urlset/xmlns:url").size)
      end

      specify "the pages should have the correct paths" do
        expect(
          subject
            .xpath("xmlns:urlset/xmlns:url/xmlns:loc")
            .map { |node| URI(node.text).path },
        ).to match_array(paths)
      end
    end

    describe "priority" do
      specify "priority should be assinged from frontmatter" do
        content_sitemap_pages.each do |path, data|
          importance = subject.at_xpath(
            %(/xmlns:urlset/xmlns:url[xmlns:loc = 'http://www.example.com#{path}']/xmlns:priority),
          ).text

          expect(importance).to eql(data[:priority].to_s)
        end
      end
    end

    describe "lastmod" do
      specify "last modified date should be assinged from frontmatter" do
        content_sitemap_pages.each do |path, data|
          last_modified = subject.at_xpath(
            %(/xmlns:urlset/xmlns:url[xmlns:loc = 'http://www.example.com#{path}']/xmlns:lastmod),
          ).text

          expect(last_modified).to eql((data[:date] || SitemapController::DEFAULT_LASTMOD).to_s)
        end
      end
    end

    describe "noindex" do
      specify "skips pages that have noindex in the frontmatter" do
        expect(subject.to_s).not_to include("/test/a")
      end
    end

    context "when a page is set to draft" do
      let(:content_pages) do
        {
          "/draft" => {
            name: "Draft page",
            draft: true,
          },
          "/published" => {
            name: "Published page",
            draft: false,
          },
        }
      end

      specify "draft pages aren't included in the sitemap" do
        expect(subject).not_to match(/draft/)
      end

      specify "published pages are included in the sitemap" do
        expect(subject).to match(/published/)
      end
    end
  end
end
