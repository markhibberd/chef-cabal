#
# Cookbook Name:: cabal
# Provider:: cabal_update
#

def whyrun_supported?
  true
end

action :update do
  index = ::File.expand_path("~#{ new_resource.user }/.cabal/packages/hackage.haskell.org/00-index.cache")

  def age
    (Time.now - ::File.mtime(index)) / 60
  end

  if !::File.exists?(index) || age > new_resource.cache_for
    converge_by("cabal update #{ new_resource.user }") do
      execute "su - #{ new_resource.user } -c 'cabal update'"
    end
  end
end
