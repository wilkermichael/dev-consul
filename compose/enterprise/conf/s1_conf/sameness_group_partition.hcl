Kind = "sameness-group"
Name = "sg1"
partition = "pt2"
DefaultForFailover = true
Members = [
  { Partition = "pt2" },
  { Partition = "default" },
  { Peer = "peer-dc2" },
]
