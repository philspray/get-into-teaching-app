import { Application } from 'stimulus' ;
import LinkController from 'link_controller.js' ;

describe('LinkController', () => {
  describe ("disabling turbolinks for links to anchors", () => {
    beforeEach(() => {
      document.body.innerHTML = `
      <div data-controller="link" data-target="link.content">
        <div id="level-1" class="video-overlay" data-target="video.player" data-action="click->video#close">
          <a href="#level-3" />
          <div id="level-2">
            <a href="#level-1" />
            <div id="level-3">
              <a href="#level-1" />
            </div>
          </div>
        </div>
      </div>`
    });

    beforeEach(() => {
      const application = Application.start();
      application.register('link', LinkController);
    })

    describe("when first loaded", () => {
      it("adds data-turbolinks attribute to all jump links", () => {
        const linkNodes = [...document.getElementsByTagName('a')];

        linkNodes.forEach((link) => { expect(link.hasAttribute('data-turbolinks')).toBe(true) });
      });

      it("sets data-turbolinks attribute to value of false", () => {
        const linkNodes = [...document.getElementsByTagName('a')];

        linkNodes.forEach((link) => { expect(link.getAttribute('data-turbolinks')).toEqual('false') });
      })
    });
  });

  describe ("making external links open in new windows", () => {
    beforeEach(() => {
      document.body.innerHTML = `
      <div data-controller="link" data-target="link.content">
        <div class="content">
          <a id="content-external-link" href="https://www.sample.com/content-link">Content external link</a>
          <a id="content-internal-link" href="/internal-link">Content internal link</a>
          <a id="content-anchor-link" href="#subheading">Content anchor link</a>
        </div>
        <a href="https://www.sample.com/non-content-link">Non-content link</a>
        <a href="https://www.sample.com/another-non-content-link">Another non-content link</a>
      </div>`
    });

    beforeEach(() => {
      const application = Application.start();
      application.register('link', LinkController);
    })

    describe("when loaded", () => {
      it("adds target='_blank' to the content external link", () => {
        const contentExternalLink = document.getElementById('content-external-link');
        expect(contentExternalLink.hasAttribute('target')).toBe(true);
      })

      it("doesn't add target='_blank' to any other links", () => {
        const linkNodes = [...document.getElementsByTagName('a')];

        linkNodes
          .filter(link => !link.href.startsWith("http"))
          .forEach((link) => {
            expect(link.hasAttribute('target')).toBe(false);
          });
      })
    });
  })
});
