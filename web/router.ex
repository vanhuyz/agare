defmodule Agare.Router do
  use Agare.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Agare do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/ideas", IdeaController
  end

  scope "/auth", Agare do
    pipe_through :browser # Use the default browser stack

    delete "/sign_out", AuthController, :sign_out
    get "/:provider", AuthController, :index
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  scope "/api", Agare.Api, as: :api do
    pipe_through :api

    resources "/ideas", IdeaController, except: [:new, :edit]
  end
end
