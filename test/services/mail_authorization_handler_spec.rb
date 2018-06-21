# coding: utf-8
# frozen_string_literal: true

require "rails_helper"
require "decidim/dev/test/authorization_shared_examples"

describe MailAuthorizationHanlder do
  let(:subject) { handler }
  let(:handler) { described_class.from_params(params) }
  let(:verification_code) { "1234" }
  let(:params) do
    {
        verification_code: verification_code
    }
  end

  it_behaves_like "an authorization handler"


end