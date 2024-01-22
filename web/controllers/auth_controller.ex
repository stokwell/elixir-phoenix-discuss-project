defmodule Discuss.AuthController do
  use Discuss.Web, :controller

  plug Ueberauth

  plug :verify_unique_state when action == :callback

  alias Discuss.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    Logger.error(%{"error" => "Error", "message" => "Action called"})
  end

  def callback(conn, %{"error" => error, "error_description" => message}) do
    require Logger
    Logger.error(%{"error" => error, "message" => message})
    conn
     |> put_flash(:error, "OAuth request failed in transit. This has been logged and will be looked into.")
  end

  # def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
  #   user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "Github"}
  #   changeset = User.changeset(%User{}, user_params)

  #   signin(conn, changeset)
  # end

  def verify_unique_state(%{path_params: %{"provider" => provider}} = conn, _) do
    require Logger
    Logger.error(%{"error" => "Error", "message" => "State"})
    conn
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: topic_path(conn, :index))
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))

      {:error, _error} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end

end
