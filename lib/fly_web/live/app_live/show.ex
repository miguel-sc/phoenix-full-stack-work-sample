defmodule FlyWeb.AppLive.Show do
  use FlyWeb, :live_view
  require Logger

  alias Fly.Client
  alias FlyWeb.Components.HeaderBreadcrumbs

  @polling_interval 5000

  @impl true
  def mount(%{"name" => name}, session, socket) do
    socket =
      assign(socket,
        config: client_config(session),
        state: :loading,
        app: nil,
        app_name: name,
        count: 0,
        authenticated: true
      )

    # Only make the API call if the websocket is setup. Not on initial render.
    if connected?(socket) do
      Process.send_after(self(), :tick, @polling_interval)
      {:ok, fetch_app(socket)}
    else
      {:ok, socket}
    end
  end

  defp client_config(session) do
    Fly.Client.config(access_token: session["auth_token"] || System.get_env("FLYIO_ACCESS_TOKEN"))
  end

  defp fetch_app(socket) do
    app_name = socket.assigns.app_name

    case Client.fetch_app(app_name, socket.assigns.config) do
      {:ok, app} ->
        assign(socket, :app, app)

      {:error, :unauthorized} ->
        put_flash(socket, :error, "Not authenticated")

      {:error, reason} ->
        Logger.error("Failed to load app '#{inspect(app_name)}'. Reason: #{inspect(reason)}")

        put_flash(socket, :error, reason)
    end
  end

  @impl true
  def handle_event("click", _params, socket) do
    {:noreply, assign(socket, count: socket.assigns.count + 1)}
  end

  @impl true
  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, @polling_interval)

    {:noreply, fetch_app(socket)}
  end

  def status_bg_color(app) do
    case app["status"] do
      "running" -> "bg-green-100"
      "dead" -> "bg-red-100"
      _ -> "bg-yellow-100"
    end
  end

  def status_text_color(app) do
    case app["status"] do
      "running" -> "text-green-800"
      "dead" -> "text-red-800"
      _ -> "text-yellow-800"
    end
  end

  def preview_url(app) do
    "https://#{app["name"]}.fly.dev"
  end

  def health_checks(allocation) do
    ["total", "passing", "warning", "critical"]
    |> Enum.filter(fn stat -> allocation["#{stat}CheckCount"] != 0 end)
    |> Enum.map(fn stat -> "#{allocation["#{stat}CheckCount"]} #{stat}" end)
    |> Enum.join(", ")
  end

  def formatted_date(date_str) do
    date_str
    |> Timex.parse!("{ISO:Extended}")
    |> Timex.format!("{relative}", :relative)
  end
end
