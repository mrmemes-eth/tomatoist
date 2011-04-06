Tomatoist.controllers :timers do
  disable :layout

  get :edit, with: :id do
    render :haml, "foo bar"
  end

  put :update, with: :id do
  end

end
