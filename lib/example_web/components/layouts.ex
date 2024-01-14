defmodule ExampleWeb.Layouts do
  use ExampleWeb, :html

  embed_templates "layouts/*"
end

defmodule ExampleWeb.CustomDomainLayouts do
  use ExampleWeb, :html

  embed_templates "layouts/custom_domain/*"
end
