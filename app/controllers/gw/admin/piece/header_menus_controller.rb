class Gw::Admin::Piece::HeaderMenusController < ApplicationController
  include System::Controller::Scaffold
  layout false

  def index
    @piece_param = params['piece_param']
    @portal_mode = Gw::Property::PortalMode.first_or_new
    
    @items = Gw::EditLinkPiece.where(id: @piece_param, published: 'opened', state: 'enabled')
      .order(sort_no: :asc, id: :asc)
  end
end
