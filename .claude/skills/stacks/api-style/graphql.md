# API Style Skill — GraphQL

## 구조
```
app/api/graphql/
└── route.ts              # Apollo Server 핸들러
graphql/
├── schema.ts             # 타입 정의
├── resolvers/
│   ├── index.ts          # 리졸버 합성
│   └── user.resolver.ts  # 도메인별 리졸버
```

## Apollo Server 설정 (app/api/graphql/route.ts)
```typescript
import { ApolloServer } from '@apollo/server'
import { startServerAndCreateNextHandler } from '@as-integrations/next'
import { typeDefs } from '@/graphql/schema'
import { resolvers } from '@/graphql/resolvers'

const server = new ApolloServer({ typeDefs, resolvers })
const handler = startServerAndCreateNextHandler(server)

export { handler as GET, handler as POST }
```

## Schema 패턴 (graphql/schema.ts)
```typescript
export const typeDefs = `#graphql
  type User {
    id: Int!
    email: String!
    name: String
    createdAt: String!
  }

  type Query {
    users: [User!]!
    user(id: Int!): User
  }

  type Mutation {
    createUser(email: String!, name: String): User!
    updateUser(id: Int!, name: String!): User
    deleteUser(id: Int!): Boolean!
  }
`
```

## Resolver 패턴 (graphql/resolvers/user.resolver.ts)
```typescript
import { userService } from '@/services/user.service'

export const userResolvers = {
  Query: {
    users: () => userService.findAll(),
    user: (_: any, { id }: { id: number }) => userService.findById(id),
  },
  Mutation: {
    createUser: (_: any, args: { email: string; name?: string }) =>
      userService.create(args),
    updateUser: (_: any, { id, ...data }: { id: number; name: string }) =>
      userService.update(id, data),
    deleteUser: async (_: any, { id }: { id: number }) => {
      await userService.delete(id)
      return true
    },
  },
}
```
