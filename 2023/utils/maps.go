package utils

func SliceToMap[K any, V comparable](input []K, mappingFunc func(K) V) map[V]K {
	m := make(map[V]K)

	for _, k := range input {
		m[mappingFunc(k)] = k
	}

	return m
}

func GroupBy[K any, V comparable](input []K, mappingFunc func(K) V) map[V][]K {
	m := make(map[V][]K)

	for _, k := range input {
		key := mappingFunc(k)
		if _, ok := m[key]; !ok {
			m[key] = make([]K, 0)
		}
		m[key] = append(m[key], k)
	}

	return m
}
