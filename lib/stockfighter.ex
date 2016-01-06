defmodule Stockfighter do

  @endpoint "https://api.stockfighter.io/ob/api"
  use HTTPoison.Base
  # override process_url in HTTPoison.Base
  defp process_url(url) do
    Path.join(@endpoint, url)
  end
end
