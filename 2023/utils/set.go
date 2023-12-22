package utils

type Set[T comparable] map[T]bool

func (s Set[T]) Add(item T) {
	s[item] = true
}

func (s Set[T]) Has(item T) bool {
	_, ok := s[item]
	return ok
}

func (s Set[T]) Delete(item T) {
	delete(s, item)
}
