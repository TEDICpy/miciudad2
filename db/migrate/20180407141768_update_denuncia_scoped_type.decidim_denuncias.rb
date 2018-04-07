# This migration comes from decidim_denuncias (originally 20171017095143)
# frozen_string_literal: true

class UpdateDenunciaScopedType < ActiveRecord::Migration[5.1]
  def up
    Decidim::Denuncia.find_each do |denuncia|
      denuncia.scoped_type = Decidim::DenunciasTypeScope.find_by(
        type: Decidim::DenunciasType.find(denuncia.type_id),
        scope: Decidim::Scope.find_by(id: denuncia.decidim_scope_id) || denuncia.organization.top_scopes.first
      )

      denuncia.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't undo initialization of mandatory attribute"
  end
end
