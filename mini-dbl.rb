$days_completed = 0
$completed = false
$delayed_timer = "Restarted 24 hour timer" # Delayed Job cycle
$sms_question = "Did you complete today's task?" # Outbound SMS for USER
$failing_sms = "Your friend failed to complete their goal today" # Outbound SMS for RECIPIENTS

### MICROPOST FORM
puts "What is your goal?"
$goal = gets.downcase
$completion_sms = "Your friend has accomplished their goal of #$goal"

puts ''
puts "How many days do you want to do your goal?"
$days = gets.to_i
$days_to_complete = $days
$days_remaining = $days
$current_day = 1
###

for i in ($days).downto(1)
    puts ''
    puts("Today is the #$current_day day" )
    puts("#$delayed_timer") # Delayed job
    puts("#$sms_question") # DJ texts User a prompt SMS 
    reply = gets.chomp.downcase
    if reply == "yes"
        puts("Cool! Thank you for being so productive")
        puts ''
        $days_completed += 1
    else
        puts("#$failing_sms")
        puts ''
    end
    $days_remaining -= 1
    $current_day += 1
end

puts "#$completion_sms for #$days_completed out of #$days_to_complete days"
$completed = true
puts("Goal complete? = #$completed")