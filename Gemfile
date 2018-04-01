# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", "0.10.0"
gem "decidim-initiatives", git: "https://github.com/decidim/decidim-initiatives", branch: "a24a1199aa5d723444dfb1d36a5494646f596936"
gem "decidim-denuncias", git: "https://github.com/diegocrzt/decidim-denuncias", branch: "linea_base_denuncias"
gem "decidim-proposals"

gem "puma", "~> 3.0"
gem "uglifier", "~> 4.1"

gem "faker", "~> 1.8"

group :development, :test do
  gem "byebug", "~> 10.0", platform: :mri

  gem "decidim-dev", "0.10.0"
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end
