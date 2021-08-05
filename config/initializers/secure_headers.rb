# rubocop:disable Lint/PercentStringArray
SecureHeaders::Configuration.default do |config|
  config.x_frame_options = "DENY"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.referrer_policy = %w[origin-when-cross-origin strict-origin-when-cross-origin]

  tta_service_hosts = []
  tta_service_hosts << URI.parse(ENV["TTA_SERVICE_URL"]).host if ENV["TTA_SERVICE_URL"].present?
  google_analytics = %w[*.google-analytics.com *.googletagmanager.com *.googleusercontent.com *.gstatic.com s.ytimg.com *.googleadservices.com *.googleads.g.doubleclick.net https://googleads.g.doubleclick.net *.googlesyndication.com]

  # curl https://www.google.com/supported_domains | sed 's!\(.*\)!"*\1",!g'
  google_analytics += [
    "*.google.com",
    "*.google.ad",
    "*.google.ae",
    "*.google.com.af",
    "*.google.com.ag",
    "*.google.com.ai",
    "*.google.al",
    "*.google.am",
    "*.google.co.ao",
    "*.google.com.ar",
    "*.google.as",
    "*.google.at",
    "*.google.com.au",
    "*.google.az",
    "*.google.ba",
    "*.google.com.bd",
    "*.google.be",
    "*.google.bf",
    "*.google.bg",
    "*.google.com.bh",
    "*.google.bi",
    "*.google.bj",
    "*.google.com.bn",
    "*.google.com.bo",
    "*.google.com.br",
    "*.google.bs",
    "*.google.bt",
    "*.google.co.bw",
    "*.google.by",
    "*.google.com.bz",
    "*.google.ca",
    "*.google.cd",
    "*.google.cf",
    "*.google.cg",
    "*.google.ch",
    "*.google.ci",
    "*.google.co.ck",
    "*.google.cl",
    "*.google.cm",
    "*.google.cn",
    "*.google.com.co",
    "*.google.co.cr",
    "*.google.com.cu",
    "*.google.cv",
    "*.google.com.cy",
    "*.google.cz",
    "*.google.de",
    "*.google.dj",
    "*.google.dk",
    "*.google.dm",
    "*.google.com.do",
    "*.google.dz",
    "*.google.com.ec",
    "*.google.ee",
    "*.google.com.eg",
    "*.google.es",
    "*.google.com.et",
    "*.google.fi",
    "*.google.com.fj",
    "*.google.fm",
    "*.google.fr",
    "*.google.ga",
    "*.google.ge",
    "*.google.gg",
    "*.google.com.gh",
    "*.google.com.gi",
    "*.google.gl",
    "*.google.gm",
    "*.google.gr",
    "*.google.com.gt",
    "*.google.gy",
    "*.google.com.hk",
    "*.google.hn",
    "*.google.hr",
    "*.google.ht",
    "*.google.hu",
    "*.google.co.id",
    "*.google.ie",
    "*.google.co.il",
    "*.google.im",
    "*.google.co.in",
    "*.google.iq",
    "*.google.is",
    "*.google.it",
    "*.google.je",
    "*.google.com.jm",
    "*.google.jo",
    "*.google.co.jp",
    "*.google.co.ke",
    "*.google.com.kh",
    "*.google.ki",
    "*.google.kg",
    "*.google.co.kr",
    "*.google.com.kw",
    "*.google.kz",
    "*.google.la",
    "*.google.com.lb",
    "*.google.li",
    "*.google.lk",
    "*.google.co.ls",
    "*.google.lt",
    "*.google.lu",
    "*.google.lv",
    "*.google.com.ly",
    "*.google.co.ma",
    "*.google.md",
    "*.google.me",
    "*.google.mg",
    "*.google.mk",
    "*.google.ml",
    "*.google.com.mm",
    "*.google.mn",
    "*.google.ms",
    "*.google.com.mt",
    "*.google.mu",
    "*.google.mv",
    "*.google.mw",
    "*.google.com.mx",
    "*.google.com.my",
    "*.google.co.mz",
    "*.google.com.na",
    "*.google.com.ng",
    "*.google.com.ni",
    "*.google.ne",
    "*.google.nl",
    "*.google.no",
    "*.google.com.np",
    "*.google.nr",
    "*.google.nu",
    "*.google.co.nz",
    "*.google.com.om",
    "*.google.com.pa",
    "*.google.com.pe",
    "*.google.com.pg",
    "*.google.com.ph",
    "*.google.com.pk",
    "*.google.pl",
    "*.google.pn",
    "*.google.com.pr",
    "*.google.ps",
    "*.google.pt",
    "*.google.com.py",
    "*.google.com.qa",
    "*.google.ro",
    "*.google.ru",
    "*.google.rw",
    "*.google.com.sa",
    "*.google.com.sb",
    "*.google.sc",
    "*.google.se",
    "*.google.com.sg",
    "*.google.sh",
    "*.google.si",
    "*.google.sk",
    "*.google.com.sl",
    "*.google.sn",
    "*.google.so",
    "*.google.sm",
    "*.google.sr",
    "*.google.st",
    "*.google.com.sv",
    "*.google.td",
    "*.google.tg",
    "*.google.co.th",
    "*.google.com.tj",
    "*.google.tl",
    "*.google.tm",
    "*.google.tn",
    "*.google.to",
    "*.google.com.tr",
    "*.google.tt",
    "*.google.com.tw",
    "*.google.co.tz",
    "*.google.com.ua",
    "*.google.co.ug",
    "*.google.co.uk",
    "*.google.com.uy",
    "*.google.co.uz",
    "*.google.com.vc",
    "*.google.co.ve",
    "*.google.vg",
    "*.google.co.vi",
    "*.google.com.vn",
    "*.google.vu",
    "*.google.ws",
    "*.google.rs",
    "*.google.co.za",
    "*.google.co.zm",
    "*.google.co.zw",
    "*.google.cat",
  ]

  lid_pixels = %w[pixelg.adswizz.com tracking.audio.thisisdax.com]

  config.csp = {
    default_src: %w['none'],
    base_uri: %w['self'],
    block_all_mixed_content: true, # see http://www.w3.org/TR/mixed-content/
    child_src: %w['self' *.youtube.com ct.pinterest.com *.snapchat.com *.hotjar.com],
    connect_src: %w['self' ct.pinterest.com *.hotjar.com vc.hotjar.io wss://*.hotjar.com *.facebook.com *.visualwebsiteoptimizer.com stats.g.doubleclick.net] + google_analytics + tta_service_hosts,
    font_src: %w['self' *.gov.uk fonts.gstatic.com],
    form_action: %w['self' *.snapchat.com *.facebook.com www.gov.uk dev.visualwebsiteoptimizer.com],
    frame_ancestors: %w['self'],
    frame_src: %w['self' embed.scribblelive.com *.snapchat.com *.facebook.com www.youtube.com www.youtube-nocookie.com *.hotjar.com *.doubleclick.net dev.visualwebsiteoptimizer.com] + google_analytics,
    img_src: %w['self' linkbam.uk *.gov.uk data: *.googleapis.com *.pinterest.com t.co *.facebook.com cx.atdmt.com *.visualwebsiteoptimizer.com *.doubleclick.net i.ytimg.com adservice.google.com adservice.google.co.uk] + google_analytics + lid_pixels,
    manifest_src: %w['self'],
    media_src: %w['self'],
    script_src: %w['self' 'unsafe-inline' 'unsafe-eval' embed.scribblelive.com *.googleapis.com *.gov.uk code.jquery.com *.facebook.net *.hotjar.com *.pinimg.com sc-static.net static.ads-twitter.com analytics.twitter.com *.youtube.com *.visualwebsiteoptimizer.com] + google_analytics + lid_pixels,
    style_src: %w['self' 'unsafe-inline' *.gov.uk *.googleapis.com] + google_analytics,
    worker_src: %w['self' *.visualwebsiteoptimizer.com blob:],
    upgrade_insecure_requests: !Rails.env.development?, # see https://www.w3.org/TR/upgrade-insecure-requests/
    report_uri: %w[/csp_reports],
  }

  if Rails.env.development?
    # Webpack-dev-server
    config.csp[:connect_src] += %w[ws: localhost:*]
  end
end
# rubocop:enable Lint/PercentStringArray
