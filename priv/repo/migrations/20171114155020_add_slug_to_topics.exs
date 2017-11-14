defmodule Discuss.Repo.Migrations.AddSlugToTopics do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      add :slug, :string
    end

    create index(:topics, [:slug], ununiq: true)
  end
end
