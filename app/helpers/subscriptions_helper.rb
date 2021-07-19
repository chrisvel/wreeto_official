module SubscriptionsHelper

  def beta_badge
		"<div class='badge badge-warning align-middle text-white ml-1'>BETA</div>"
	end

  def plan_badge(user)
    plan = user.current_plan
    case plan 
    when :free
		  "<div class='badge badge-secondary align-middle text-white ml-1'>FREE</div>"
    when :trial 
      "<div class='badge badge-danger align-middle text-white ml-1'>TRIAL</div>"
    when :premium 
      "<div class='badge badge-warning align-middle text-white ml-1'>PREMIUM</div>"
    end
	end

  def disable_inquiry(user)
    current_user.inquiries.interest_in_premium_plan.any? ? 'disabled' : '' 
  end
end
