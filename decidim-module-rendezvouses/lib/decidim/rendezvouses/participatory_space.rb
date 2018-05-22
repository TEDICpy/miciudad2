# frozen_string_literal: true

Decidim.register_participatory_space(:rendezvouses) do |participatory_space|
  participatory_space.context(:public) do |context|
    context.engine = Decidim::Rendezvouses::Engine
    context.layout = "layouts/decidim/rendezvous"
  end

  participatory_space.context(:admin) do |context|
    context.engine = Decidim::Rendezvouses::AdminEngine
    context.layout = "layouts/decidim/admin/rendezvouses"
  end

  participatory_space.participatory_spaces do |organization|
    Decidim::Rendezvous.where(organization: organization)
  end

  participatory_space.model_class_name = "Decidim::Rendezvous"
end