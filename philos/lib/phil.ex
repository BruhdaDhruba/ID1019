defmodule Phil do
  def start(name, left, right, hunger, strength, ctrl) do
    spawn_link(fn -> dreaming(name, left, right, hunger, strength, ctrl) end)
  end

  def dreaming(name, _, _, 0, strength, ctrl) do
    IO.puts(" #{name} is happy (strength #{strength})")
    send(ctrl, :done)
  end
  def dreaming(name, _,_,hunger,0, ctrl) do
    IO.puts("#{name} has starved\n")
    send(ctrl, :done)
  end

  def dreaming(name, left, right, hunger, strength, ctrl) do
    sleep(5000)
    #IO.puts("#{name} woke up and has strength #{strength} left\n")
    waiting(name, left, right, hunger, strength, ctrl)
  end

  def waiting(name, left, right, hunger, strength, ctrl) do
    ref = make_ref() #request chopstick with reference
    Chop.request(left,ref)
    Chop.request(right,ref)
    case Chop.wait(ref, 1) do
      :ok ->
        sleep(100)
        case Chop.wait(ref,1) do
          :ok ->
            eating(name, left, right, hunger, strength, ctrl,ref)

          :sorry ->
            Chop.return(left,ref)
            Chop.return(right,ref)
            dreaming(name, left, right, hunger, strength - 1, ctrl)
        end
      :sorry ->
        Chop.return(left,ref)
        Chop.return(right,ref)
        dreaming(name, left, right, hunger, strength - 1, ctrl)
    end
  end

      # case chop request do.. (go back dreaming if sorry and decrease strength) if :sorry return the first one you got
    # problem if you grant while phil is asleep -> cancel request[!!!!] by returning both if you dont get the second because
    # is still a request in the pipeline
  # asynchronous request both and then wait and take these return values as before

  def eating(name, left, right, hunger, strength, ctrl,ref) do
    #IO.puts("#{name} is eating and has #{hunger} hunger left\n")
    Chop.return(left,ref)
    sleep(4)
    Chop.return(right,ref)
    dreaming(name, left, right, hunger - 1, strength, ctrl)
  end

  def sleep(0) do
    :ok
  end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end

end
