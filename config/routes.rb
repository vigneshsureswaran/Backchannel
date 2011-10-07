Backchannel::Application.routes.draw do
  root :to => "users#index"
    get "posts/showreplies"

    get "posts/report"

    get "users/report"

    post "users/authenticate"

    get "users/login"

    get "users/reports"

    get "users/showallusers"

    post "posts/votes"

    get "posts/countvotes"

    resources :votes

    get "users/logout"

    post "posts/reply"

    get "posts/index"

    get "posts/createreply"

    get "posts/showrepliesUser"

    get "posts/showrepliesText"

    post "posts/searchByUser"

    post "posts/searchByText"

    resources :posts
    resources :users
    root :controller=>  "users", :action=> "authenticate"


end
