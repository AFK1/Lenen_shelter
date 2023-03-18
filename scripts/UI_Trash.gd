extends Control


func delete_children():
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
