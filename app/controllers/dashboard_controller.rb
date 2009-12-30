class DashboardController < ApplicationController
  def index
    @text = render_cell :album_selector, :display
  end
end
