class ProfileSweeper < ActionController::Caching::Sweeper
  observe Profile
  
  def after_update(profile)
    expire_profile_cache(profile)
  end
  
  def after_create(profile)
    expire_profile_cache(profile)
  end
  
  def after_destroy(profile)
    expire_profile_cache(profile)
  end
  
  private
  def expire_profile_cache(profile)
    # expire the entire cache since the changes to profile are displayed everywhere!
    expire_fragment(%r{.})
  end
end