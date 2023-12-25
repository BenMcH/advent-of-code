package utils

import "maps"

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

func (s Set[T]) Clone() Set[T] {
	return maps.Clone(s)
}

func (s Set[T]) AddAllFromSet(s1 Set[T]) {
	for v := range s1 {
		s.Add(v)
	}
}
