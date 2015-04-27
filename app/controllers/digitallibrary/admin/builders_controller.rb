class Digitallibrary::Admin::BuildersController < Gw::Controller::Admin::Base
  include System::Controller::Scaffold
  layout "admin/template/portal_1column"

  def pre_dispatch
    Page.title = "電子図書"
  end

  def index
  end

  def create
    create_bbs_board
    redirect_to '/digitallibrary/'
  end

  def create_bbs_board
    item = Gwboard::Group.where(:id => Core.user_group.id).select('id, code, name')
    return item if item.blank?

    params[:title] = "電子図書(#{Core.user_group.name})" if params[:title].blank?
    params[:separator_str1] = '.' if params[:separator_str1].blank?
    params[:separator_str2] = '.' if params[:separator_str2].blank?

    item = Digitallibrary::Control.create({
      :state => 'public' ,
      :published_at => Core.now ,
      :importance => '1' ,
      :category => '0' ,
      :left_index_use => '1',
      :category1_name => '見出し' ,
      :recognize => '0' ,
      :default_published => 3,
      :upload_graphic_file_size_capacity => 30,
      :upload_graphic_file_size_capacity_unit => 'MB',
      :upload_document_file_size_capacity => 60,
      :upload_document_file_size_capacity_unit => 'MB',
      :upload_graphic_file_size_max => 3,
      :upload_document_file_size_max => 4,
      :upload_graphic_file_size_currently => 0,
      :upload_document_file_size_currently => 0,
      :sort_no => 0 ,
      :view_hide => 1 ,
      :categoey_view  => 1 ,
      :categoey_view_line => 0 ,
      :monthly_view => 1 ,
      :monthly_view_line => 6 ,
      :default_limit => '20',
      :form_name => 'form001',
      :title => params[:title],
      :separator_str1 => params[:separator_str1],
      :separator_str2 => params[:separator_str2],
      :admingrps_json => %Q{[["#{item.code}", "#{item.id}", "#{item.name}"]]},
      :adms_json => "[]",
      :editors_json => %Q{[["#{item.code}", "#{item.id}", "#{item.name}"]]},
      :readers_json => %Q{[["#{item.code}", "#{item.id}", "#{item.name}"]]}
    })
  end
end
