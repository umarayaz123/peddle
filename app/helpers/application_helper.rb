module ApplicationHelper

  def duration(time)
    secs  = time.to_int
    mins  = secs / 60
    hours = mins / 60
    days  = hours / 24

    if days > 0
      "#{days} days and #{hours % 24} hours"
    elsif hours > 0
      "#{hours} hours and #{mins % 60} minutes"
    elsif mins > 0
      "#{mins} minutes and #{secs % 60} seconds"
    elsif secs >= 0
      "#{secs} seconds"
    end
  end

  def show_user_bg
    # Show user background
    if user_signed_in?
      "background:transparent url(#{current_user.bg_image.snap}) repeat-x fixed left top !important;" unless current_user.bg_image.nil?
      # Otherwise, show a default background image
    else
      #"background:transparent url('/images/default_bg.png') no-repeat fixed left top;"
    end
  end


end
