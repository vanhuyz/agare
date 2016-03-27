defmodule Agare.AuthController do
  require Logger
  use Agare.Web, :controller

  alias Agare.User

  def index(conn, %{"provider" => provider}) do
    redirect conn, external: authorize_url!(provider)
  end

  def callback(conn, %{"provider" => provider, "code" => code}) do
    token = get_token!(provider, code)
    user_body = get_user!(provider, token)
    user_params = Map.take(user_body, ["email","name","picture"])

    changeset = User.changeset(%User{}, user_params)

    if user = Repo.get_by(User, email: user_params["email"]) do
      conn
      |> put_flash(:info, "Signed in successfully.")
      |> put_session(:current_user_id, user.id)
      |> put_session(:access_token, token.access_token)
      |> redirect(to: "/")      
    else
      case Repo.insert(changeset) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "Signed in successfully.")
          |> put_session(:current_user_id, user.id)
          |> put_session(:access_token, token.access_token)
          |> redirect(to: "/")
        {:error, _changeset} ->
          conn
          |> put_flash(:error, "Unable to sign in.")
          |> redirect(to: "/")
      end
    end
  end

  def sign_out(conn, _) do
    conn
    |> clear_session
    |> redirect to: "/"
  end

  defp authorize_url!("google") do
    Google.authorize_url!(scope: "email profile")
  end

  defp authorize_url!(_) do
    raise "No matching provider available"
  end

  defp get_token!("google", code) do
    Google.get_token!(code: code)
  end

  defp get_token!(_, _) do
    raise "No matching provider available"
  end

  defp get_user!("google", token) do
    user_url = "https://www.googleapis.com/plus/v1/people/me/openIdConnect"
    OAuth2.AccessToken.get!(token, user_url).body
  end
end
