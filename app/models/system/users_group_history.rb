class System::UsersGroupHistory < ActiveRecord::Base
  include System::Model::Base
  include System::Model::Base::Content

  self.primary_key = 'rid'

  belongs_to :user,  :foreign_key => :user_id,  :class_name => 'System::User'
  belongs_to :group, :foreign_key => :group_id, :class_name => 'System::GroupHistory'

  validates_presence_of :group_id,:user_id,:start_at
  validates_each :end_at do |record, attr, value|
    record.errors.add attr, 'には適用開始日以降の日付を入力してください'  if value.blank? ? false : (value < record.start_at)
  end

  before_save :set_columns

  def self.select_state
    I18n.a('enum.system/users_group.job_order')
  end

  def self.ldap_show(ldap)
    I18n.t('enum.system/user.ldap')[ldap.to_i]
  end

  def self.get_user_select(g_id=nil,all=nil,current=Time.now)
    selects = []
    selects << ['すべて',0] if all=='all'
    if g_id.blank?
      u = Core.user
      g = u.groups[0]
      gid = g.id
    else
      gid = g_id
    end
    today = current.strftime("%Y-%m-%d %H:%M:%S")
    cond  = "group_id = #{gid} and start_at >= '#{today}' and (end_at IS NULL or end_at = '0000-00-00 00:00:00' or end_at >= #{today})"
    order = "start_at DESC , end_at IS null , end_at DESC"
    users = System::UsersGroupHistory.where(cond).order(order)
    if users.blank?
    else
      users.each do |u|
        selects << [u.name+'('+u.code+')' , u.id]
      end
    end
    return selects
  end

  def search(params)
    params.each do |n, v|
      next if v.to_s == ''

      case n
        when 's_keyword'
        search_keyword v, :job_order
        when 'job'
        search_id v, :job_order
      end
    end if params.size != 0

    return self
  end

  def self.clear_group_historty_relations(user,g_h_id)
    cond = "user_id = #{user.id} and group_id=#{g_h_id}"
    order = "start_at DESC"
    user_group1 = System::UsersGroupHistory.where(cond).order(order).first
    unless user_group1.blank?
      user_group1.end_at = nil
      user_group1.save
      return user_group1
    end
    return nil
  end

private

  def set_columns
    if self.user_id.to_i==0
        self.user_code  = '未登録ユーザー'
    else
      if self.user.blank?
        self.user_code  = '未登録ユーザー'
      else
        self.user_code  = self.user.code
      end
    end
    if self.group_id.to_i==0
        self.group_code  = '未登録グループ'
    else
      if self.group.blank?
        self.group_code  = '未登録グループ'
      else
        self.group_code  = self.group.code
      end
    end
  end
end
