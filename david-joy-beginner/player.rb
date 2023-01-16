class Player

  def initialize(maxHeath = 20)
    @maxHeath = maxHeath
    @health = maxHeath

    @direction = :forward

    @consecutiveAttacks = 0

    @turn = 0
  end


  def play_turn(warrior)
    fullHealth = warrior.health == @maxHeath
    @turn += 1
    behind = closestInDirection(warrior.look(:backward))

    if (behind != "wall") && @turn == 1
      # if there is nothing but wall directly behind, don't look
      changeDirection(warrior)
      return
    end
      

    # something is in front
    closest = closestInDirection(warrior.look)
    
    # something is directly in front
    if (!warrior.feel.empty?)

      if (warrior.feel.captive?)
        warrior.rescue!

      elsif (warrior.feel.wall?)
        changeDirection(warrior)

      else
        # create attacks where we can escape
        if (warrior.health < 0.3 * @maxHeath)
          changeDirection(warrior)
        else
          warrior.attack!
        end
      end

    elsif (closest == "Sludge" || closest == "Thick Sludge" || closest == "Archer" || closest == "Wizard")
      warrior.shoot!

    # rest if we need health AND we're not taking any damage
    elsif (warrior.health < @maxHeath && warrior.health >= @health)
      warrior.rest!

    # if the warrior is too injured to go forward, go back to recoup
    elsif (warrior.health <= 0.5 * @maxHeath)
      if (@direction == :backward)
        changeDirection(warrior)
      else
        warrior.walk!
      end
    else
      warrior.walk!

    end

    @health = warrior.health
  end

  def changeDirection(warrior)
    warrior.pivot!
    if (@direction == :forward)
      @direction = :backward
    else
      @direction = :forward
    end
  end

  def closestInDirection(front)
    # something is in front
    closest = "nothing"
    while front.length()
      if front[0]::to_s != 'nothing'
        closest = front[0]::to_s
        break
      else
        front = front.drop(1)
      end
    end
    return closest
  end

end
