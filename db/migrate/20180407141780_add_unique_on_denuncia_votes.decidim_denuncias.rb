# This migration comes from decidim_denuncias (originally 20171214161410)
# This migration comes from decidim_denuncias (originally 20171214161410)
# frozen_string_literal: true

class AddUniqueOnDenunciaVotes < ActiveRecord::Migration[5.1]
  def get_duplicates(*columns)
    Decidim::DenunciasVote.select("#{columns.join(",")}, COUNT(*)").group(columns).having("COUNT(*) > 1")
  end

  def row_count(issue)
    Decidim::DenunciasVote.where(
      decidim_denuncia_id: issue.decidim_denuncia_id,
      decidim_author_id: issue.decidim_author_id,
      decidim_user_group_id: issue.decidim_user_group_id
    ).count
  end

  def find_next(issue)
    Decidim::DenunciasVote.find_by(
        decidim_denuncia_id: issue.decidim_denuncia_id,
        decidim_author_id: issue.decidim_author_id,
        decidim_user_group_id: issue.decidim_user_group_id
    )
  end

  def up
    columns = [:decidim_denuncia_id, :decidim_author_id, :decidim_user_group_id]

    get_duplicates(columns).each do |issue|
      find_next(issue)&.destroy while row_count(issue) > 1
    end

    add_index :decidim_denuncias_votes,
              columns,
              unique: true,
              name: "decidim_denuncias_voutes_author_uniqueness_index"
  end
end
