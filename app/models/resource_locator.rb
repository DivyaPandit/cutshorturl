class ResourceLocator
  include Mongoid::Document
  include Mongoid::Timestamps

  field :given_url, type: String
  field :mini_url,  type: String
  field :clicks , type: Integer , default: 0

  default_scope -> { desc(:clicks)}
  validates :given_url , presence: true
  validates :mini_url, uniqueness: true
  validates_format_of :given_url, :with => URI::regexp(%w(http https))

  before_create :create_short_url

  # Public method to view slug along with BASE_URL
  # 
  # returns url to display with mini url
  #
  def view_mini_url
   SHORT_API_URL + self.mini_url
  end

  private
  # Private method to create slug/mini_url for given url in before_create callback
  # 
  # set mini url to callback object
  #
  def create_short_url
    character_set = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
    mini_url = (0..6).map{ character_set[rand(character_set.size)] }.join
    until ResourceLocator.where(mini_url: mini_url).count == 0 
      mini_url = (0...6).map{ character_set[rand(character_set.size)] }.join
    end
    self.mini_url = mini_url
  end
end
