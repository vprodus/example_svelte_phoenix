defmodule ExampleWeb.Router do
  use ExampleWeb, :router

  import ExampleWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ExampleWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :custom_domain_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug ExampleWeb.CustomDomainsPlug
  end

  pipeline :custom_domains do
    ExampleWeb.CustomDomainsPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  ## Authentication routes
  scope "/", ExampleWeb, host: Application.compile_env(:example, :primary_domains, ["localhost"]) do
    scope "/" do
      pipe_through [:browser, :redirect_if_user_is_authenticated]

      live_session :redirect_if_user_is_authenticated,
        on_mount: [{ExampleWeb.UserAuth, :redirect_if_user_is_authenticated}] do
        live "/users/register", UserRegistrationLive, :new
        live "/users/log_in", UserLoginLive, :new
        live "/users/reset_password", UserForgotPasswordLive, :new
        live "/users/reset_password/:token", UserResetPasswordLive, :edit
      end

      post "/users/log_in", UserSessionController, :create
    end

    scope "/" do
      pipe_through [:browser, :require_authenticated_user]

      get "/simple", PageController, :svelte_1
      get "/plus-minus-svelte", PageController, :svelte_2
      get "/lodash", PageController, :svelte_3
      live "/plus-minus-liveview", LiveExample1
      live "/counter", LiveExample2
      live "/plus-minus-hybrid", LiveExample3
      live "/log-list", LiveExample4
      live "/breaking-news", LiveExample5
      live "/chat", LiveExample6
      live "/lights", LiveLights
      live "/struct", LiveStruct
      live "/sigil", LiveSigil
      live "/svelvet", LiveSvelvet
      live "/live-json", LiveJson
      live "/slots-experiment", LiveSlotsExperiment
      live "/svelte-2", LiveSvelte2
      live "/svelte-1", LiveSvelte1

      live_session :require_authenticated_user,
        on_mount: [{ExampleWeb.UserAuth, :ensure_authenticated}] do
        live "/users/settings", UserSettingsLive, :edit
        live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

        live "/shops", ShopLive.Index, :index
        live "/shops/new", ShopLive.Index, :new
        live "/shops/:id/edit", ShopLive.Index, :edit

        live "/shops/:shop_id/products/new", ProductLive.Index, :new
        live "/shops/:shop_id/products/:id/edit", ProductLive.Index, :edit
        live "/shops/:shop_id/products/:product_id/show/edit", ProductLive.Show, :edit
      end
    end

    scope "/" do
      pipe_through :browser

      live_session :public_current_user,
        on_mount: [{ExampleWeb.UserAuth, :mount_current_user}] do
        live "/", ShopLive.Index, :index
        live "/shops/:shop_id", ProductLive.Index, :index
        live "/shops/:shop_id/products/:product_id", ProductLive.Show, :show
      end
    end

    scope "/" do
      pipe_through [:browser]

      delete "/users/log_out", UserSessionController, :delete

      live_session :current_user,
        on_mount: [{ExampleWeb.UserAuth, :mount_current_user}] do
        live "/users/confirm/:token", UserConfirmationLive, :edit
        live "/users/confirm", UserConfirmationInstructionsLive, :new
      end
    end
  end

  # A catch-all scope for any other hosts (custom domains).
  scope "/", ExampleWeb do
    pipe_through [
      # a duplicate of the :browser pipeline, minus the layout plug (set below)
      :custom_domain_browser,
      # a plug that checks for a header or a hostname other than the primary, and
      # sets it in the session as the custom domain.
      :custom_domains
    ]

    live_session :custom_domain_shop, [
      # assigns the custom domain and shop struct to every liveview in this block
      on_mount: [{ExampleWeb.CustomDomainLiveviewHooks, :load_shop_for_custom_domain}],
      layout: {ExampleWeb.CustomDomainLayouts, :root}
    ] do
      live "/", CustomDomainShopLive, :index
      live "/:product_slug", CustomDomainProductLive, :index
    end
  end
end
