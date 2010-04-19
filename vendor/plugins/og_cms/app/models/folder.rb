  class Folder
    include MongoMapper::Document
    include MongoMapper::Acts::Tree
  include Slug
  include Sortable

    key :name, String
    key :user_id, String
    key :role, String, :default => User::ROLE_NONE


  slug :name
  sortable :parent_id

    belongs_to :user
    
    acts_as_tree

    many :images


  def name_with_user
    "#{self.name} (#{self.user_id})"
  end

  def empty?
    self.children.blank? && images.blank?
  end

  def path
    p = self.name.reverse
    fp = parent
    while fp
      p += "/" + fp.name.reverse
      fp = fp.parent
    end
    p += "/"
    p.reverse
  end

  def self.roots_for_user(user)
#    folders_all = Folder.roots
#    folders = []
#      for f in folders_all
#        folders << f if (f.permissions_for?(Cms.user) && (CMS_CONFIG['share_objects']==1 || (f.site_id == Cms.site.id)))
#      end
#    folders
#
#    min = 30
#    Test.all(:conditions => {"$where" => "combine(this) > #{min}"}
      if user
#    Folder.all(:where => "parent_id.eq(#{nil}) && (user_id.eq(#{user.id}) || role.in(#{user.roles}))")
        re_parent_id = Regexp.new("^$", 'i').to_json
        re_user_id = Regexp.new("^" + Regexp.escape(user.id) + "$", 'i').to_json
        re_role = Regexp.new(user.roles.map{|r| "^" + Regexp.escape(r) + "$"}.join("|"), 'i').to_json
        Folder.all("$where" => "this.parent_id.match(#{re_parent_id}) && (this.user_id.match(#{re_user_id}) || this.role.match(#{re_role}))")
      else
        []
        end
  end
  def self.roots_for_admin()
    Folder.roots
  end
  def children_for_user(user)
      if user
        re_parent_id = Regexp.new("^" + Regexp.escape(self.id) + "$", 'i').to_json
        re_user_id = Regexp.new("^" + Regexp.escape(user.id) + "$", 'i').to_json
        re_role = Regexp.new(user.roles.map{|r| "^" + Regexp.escape(r) + "$"}.join("|"), 'i').to_json
#        Folder.all(:where => "parent_id.eq(#{self.id}) && (user_id.eq(#{user.id}) || role.in(#{user.roles}))")
        Folder.all("$where" => "this.parent_id.match(#{re_parent_id}) && (this.user_id.match(#{re_user_id}) || this.role.match(#{re_role}))")
      else
        []
      end
  end
  def update_descendants_role
    for f in self.descendants
      f.role = self.role
      f.save
    end
  end


  end