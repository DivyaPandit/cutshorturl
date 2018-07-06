class HomeController < ApplicationController


  ## Action: index
    # Purpose: To render first 100 trending links based on clicks.
    # URL:     root path
    # Response: Return 100 resource locator based on clicks
    ##
  def index
    @resource_links = ResourceLocator.all.limit(100)
  end
end
