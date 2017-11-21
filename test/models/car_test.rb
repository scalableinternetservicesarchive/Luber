require 'test_helper'

class CarTest < ActiveSupport::TestCase
  def setup
    u = User.create!(username: 'Example User', email: 'user@example.com', password: 'foobar', password_confirmation: 'foobar')
    @car = Car.create!(user_id: u.id, make: 'Honda', model: 'Civic', year: 2011, color: 'blue', license_plate: '3asd234')
    puts "New car valid?: #{@car.valid?}"
  end

  test 'license plate len 2 ok' do
    @car.license_plate = '12'
    assert @car.valid?
  end

  test 'license plate len 7 ok' do
    @car.license_plate = '1234567'
    assert @car.valid?
  end

  test 'license plate len 8 not ok' do
    @car.license_plate = '12345678'
    assert @car.invalid?
  end

  test 'license plate len 1 not ok' do
    @car.license_plate = '1'
    assert @car.invalid?
  end

  test 'license plate has illegal char' do
    @car.license_plate = '6we!123'
    assert @car.invalid?
  end

  test 'license plate has only let, num, spaces' do
    @car.license_plate = '6wer123'
    assert @car.valid?
  end

  test 'license plate has at least 2 non-sp characters' do
    @car.license_plate = '1     2'
    assert @car.valid?
  end

  test 'year should be after 1900' do
    @car.year = 1899
    assert_not @car.valid?
  end

  test 'year, make, model, and color must exist' do
    @car.year = nil
    assert_not @car.valid?
    @car.reload

    @car.make = ''
    assert_not @car.valid?
    @car.reload

    @car.model = ''
    assert_not @car.valid?
    @car.reload

    @car.color = ''
    assert_not @car.valid?
  end

  test 'year must be integer greater than 1900' do
    @car.year = 1900.01
    assert_not @car.valid?
  end

  test 'color can only be characters, no numbers or symbols' do
    @car.color = '72'
    assert_not @car.valid?
    @car.reload

    @car.color = 'l33t c0d3'
    assert_not @car.valid?
    @car.reload

    @car.color = 'heliotrope'
    assert @car.valid?
  end

  test 'make, model, and color cannot be too long' do
    @car.make = "I thought not. It's not a story the Jedi would tell you. It's a
                Sith legend. Darth Plagueis was a Dark Lord of the Sith, so
                powerful and so wise he could use the Force to influence the
                midichlorians to create life... He had such a knowledge of the
                dark side that he could even keep the ones he cared about from
                dying. The dark side of the Force is a pathway to many abilities
                some consider to be unnatural. He became so powerful... the only
                thing he was afraid of was losing his power, which eventually, of
                course, he did. Unfortunately, he taught his apprentice everything
                he knew, then his apprentice killed him in his sleep. Ironic, he
                could save others from death, but not himself."
    assert_not @car.valid?
    @car.reload

    @car.model = 'What the fuck did you just fucking say about me, you little bitch? I’ll have you know I graduated top
                  of my class in the Navy Seals, and I’ve been involved in numerous secret raids on Al-Quaeda, and I
                  have over 300 confirmed kills. I am trained in gorilla warfare and I’m the top sniper in the entire
                  US armed forces. You are nothing to me but just another target. I will wipe you the fuck out with
                  precision the likes of which has never been seen before on this Earth, mark my fucking words.
                  You think you can get away with saying that shit to me over the Internet? Think again, fucker. As we
                  speak I am contacting my secret network of spies across the USA and your IP is being traced right now
                  so you better prepare for the storm, maggot. The storm that wipes out the pathetic little thing you
                  call your life. You’re fucking dead, kid. I can be anywhere, anytime, and I can kill you in over seven
                  hundred ways, and that’s just with my bare hands. Not only am I extensively trained in unarmed combat,
                  but I have access to the entire arsenal of the United States Marine Corps and I will use it to its
                  full extent to wipe your miserable ass off the face of the continent, you little shit. If only you
                  could have known what unholy retribution your little “clever” comment was about to bring down upon
                  you, maybe you would have held your fucking tongue. But you couldn’t, you didn’t, and now you’re
                  paying the price, you goddamn idiot. I will shit fury all over you and you will drown in it. You’re
                  fucking dead, kiddo.'
    assert_not @car.valid?
    @car.reload

    @car.color = 'The intent is to provide players with a sense of pride and accomplishment for unlocking different heroes.
                  As for cost, we selected initial values based upon data from the Open Beta and other adjustments made
                  to milestone rewards before launch. Among other things, we re looking at average per-player credit
                  earn rates on a daily basis, and we ll be making constant adjustments to ensure that players have
                  challenges that are compelling, rewarding, and of course attainable via gameplay. We appreciate the
                  candid feedback, and the passion the community has put forth around the current
                  topics here on Reddit, our forums and across numerous social media outlets. Our
                  team will continue to make changes and monitor community feedback and update
                  everyone as soon and as often as we can.'
    assert_not @car.valid?
  end
end
