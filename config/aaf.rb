ActsAsFerret::define_index('shared',
 :models => {
   Artist => {:fields => [:name]},
   Song => {:fields => [:title]},
   Album => {:fields => [:title]}
 }
)