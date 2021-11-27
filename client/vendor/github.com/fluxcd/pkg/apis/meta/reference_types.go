/*
Copyright 2020, 2021 The Flux authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package meta

// LocalObjectReference contains enough information to let you locate
// the referenced object inside the same namespace
type LocalObjectReference struct {
	// Name of the referent
	// +required
	Name string `json:"name"`
}

// NamespacedObjectReference contains enough information to let you locate
// the referenced object in any namespace
type NamespacedObjectReference struct {
	// Name of the referent
	// +required
	Name string `json:"name"`

	// Namespace of the referent,
	// when not specified it acts as LocalObjectReference
	// +optional
	Namespace string `json:"namespace,omitempty"`
}

// NamespacedObjectKindReference contains enough information to let you locate
// the typed referenced object in any namespace
type NamespacedObjectKindReference struct {
	// API version of the referent,
	// if not specified the Kubernetes preferred version will be used
	// +optional
	APIVersion string `json:"apiVersion,omitempty"`

	// Kind of the referent
	// +required
	Kind string `json:"kind"`

	// Name of the referent
	// +required
	Name string `json:"name"`

	// Namespace of the referent,
	// when not specified it acts as LocalObjectReference
	// +optional
	Namespace string `json:"namespace,omitempty"`
}
