// Code generated by "enumer -type=stampType -trimprefix=stampType -text -transform=kebab -output enums_stamptype.go"; DO NOT EDIT.

//
package imagine

import (
	"fmt"
)

const _stampTypeName = "noneincreasingrandom"

var _stampTypeIndex = [...]uint8{0, 4, 14, 20}

func (i stampType) String() string {
	if i < 0 || i >= stampType(len(_stampTypeIndex)-1) {
		return fmt.Sprintf("stampType(%d)", i)
	}
	return _stampTypeName[_stampTypeIndex[i]:_stampTypeIndex[i+1]]
}

var _stampTypeValues = []stampType{0, 1, 2}

var _stampTypeNameToValueMap = map[string]stampType{
	_stampTypeName[0:4]:   0,
	_stampTypeName[4:14]:  1,
	_stampTypeName[14:20]: 2,
}

// stampTypeString retrieves an enum value from the enum constants string name.
// Throws an error if the param is not part of the enum.
func stampTypeString(s string) (stampType, error) {
	if val, ok := _stampTypeNameToValueMap[s]; ok {
		return val, nil
	}
	return 0, fmt.Errorf("%s does not belong to stampType values", s)
}

// stampTypeValues returns all values of the enum
func stampTypeValues() []stampType {
	return _stampTypeValues
}

// IsAstampType returns "true" if the value is listed in the enum definition. "false" otherwise
func (i stampType) IsAstampType() bool {
	for _, v := range _stampTypeValues {
		if i == v {
			return true
		}
	}
	return false
}

// MarshalText implements the encoding.TextMarshaler interface for stampType
func (i stampType) MarshalText() ([]byte, error) {
	return []byte(i.String()), nil
}

// UnmarshalText implements the encoding.TextUnmarshaler interface for stampType
func (i *stampType) UnmarshalText(text []byte) error {
	var err error
	*i, err = stampTypeString(string(text))
	return err
}
