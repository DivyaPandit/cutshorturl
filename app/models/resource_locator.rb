class ResourceLocator
  include Mongoid::Document
  include Mongoid::Timestamps

  field :given_url, type: String 
  field :mini_url,  type: String 
  field :clicks , type: Integer , default: 0
  field :title, type: String

  default_scope -> { desc(:clicks)}
  validates :given_url , presence: true 

  before_create :create_short_url

  def view_mini_url
   SHORT_API_URL + self.mini_url
  end

  private
  def create_short_url
    character_set = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
    mini_url = (0..6).map{ character_set[rand(character_set.size)] }.join
    until ResourceLocator.where(mini_url: mini_url).count == 0 
      mini_url = (0..6).map{ character_set[rand(character_set.size)] }.join
    end
    self.mini_url = mini_url
  end
end
