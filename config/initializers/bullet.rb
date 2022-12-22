Rails.application.configure do
  if Rails.env.development?
    config.after_initialize do
      Bullet.enable        = true
      Bullet.bullet_logger = true
      Bullet.console       = true
      Bullet.add_footer    = true
    end
  end
end

