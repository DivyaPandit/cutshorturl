class HomeController < ApplicationController

  def index
    @resource_links = ResourceLocator.all
  end
end
