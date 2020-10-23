use serde::Deserialize;
use serde::Serialize;

use super::LanguageRelationDefinition;

const LANGUAGE_RELATIONS_QUERY: &str = "
    {
        language_relations: __type(name: \"LanguageRelation\") {
            enumValues {
                name
            }
        }
    }
";

graphql_query_builder! {
    LanguageRelationsRequest,
    LanguageRelationsRequestBody,
    Variables,
    LANGUAGE_RELATIONS_QUERY,
    LanguageRelationsResponseBody,
    LanguageRelationsResponseData,
    FetchLanguageRelations,
    FetchActionLanguageRelations
}

#[derive(Debug, Clone, Default, Serialize, Deserialize, PartialEq)]
pub struct Variables {}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct LanguageRelationsResponseData {
    pub language_relations: LanguageRelationDefinition,
}

impl Default for LanguageRelationsResponseData {
    fn default() -> LanguageRelationsResponseData {
        LanguageRelationsResponseData {
            language_relations: LanguageRelationDefinition {
                enum_values: vec![],
            },
        }
    }
}
