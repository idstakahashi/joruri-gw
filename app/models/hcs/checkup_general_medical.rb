class Hcs::CheckupGeneralMedical < Hcs::CheckupDatabase
  include System::Model::Base
  include System::Model::Base::Content

  def checkup_show_url
    "/_admin/gw/link_sso/redirect_to_joruri?to=hcs&path=/hcs/checkup/general_medicals/#{self.id}"
  end
end
