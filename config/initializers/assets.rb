# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
Rails.application.config.assets.precompile += %w(appviews.css cssanimations.css dashboards.css forms.css gallery.css graphs.css mailbox.css miscellaneous.css pages.css tables.css uielements.css widgets.css commerce.css)
Rails.application.config.assets.precompile += %w(appviews.js cssanimations.js dashboards.js forms.js gallery.js graphs.js mailbox.js miscellaneous.js pages.js tables.js uielements.js widgets.js commerce.js metrics.js landing.js)
