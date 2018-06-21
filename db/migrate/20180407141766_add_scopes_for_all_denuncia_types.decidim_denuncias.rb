# This migration comes from decidim_denuncias (originally 20171017091734)
# frozen_string_literal: true

class AddScopesForAllDenunciaTypes < ActiveRecord::Migration[5.1]
  def up
    # This migrantion intent is simply to keep seed data at staging
    # environment consistent with the underlying data model. It is
    # not relevant for production environments.
    Decidim::Organization.find_each do |organization|
      Decidim::DenunciasType.where(organization: organization).find_each do |type|
        organization.scopes.each do |scope|
          Decidim::DenunciasTypeScope.create(
            type: type,
            scope: scope,
            supports_required: 1000
          )
        end
      end
    end
  end

  def down
    Decidim::DenunciasTypeScope.destroy_all
  end
end
