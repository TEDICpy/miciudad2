# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", "0.10.1"

gem "decidim-initiatives", git: "https://github.com/TEDICpy/decidim-initiatives", branch: "development"
gem "decidim-denuncias", git: "https://github.com/TEDICpy/decidim-reportes", branch: "development"
gem "decidim-rendezvouses", git: "https://github.com/TEDICpy/decidim-eventos", branch: "development"

gem "puma", "~> 3.0"
gem "uglifier", "~> 4.1"
gem "high_voltage", "~> 3.0.0"

gem "faker", "~> 1.8"

group :development, :test do
  gem "byebug", "~> 10.0", platform: :mri

  gem "decidim-dev", "0.10.1"
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end
