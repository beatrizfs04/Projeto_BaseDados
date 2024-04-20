import NextAuth from "next-auth"
import CredentialsProvider from 'next-auth/providers/credentials'
import pool from '../../../../services/pool'
import bcrypt from "bcrypt";
import { signIn } from "next-auth/react";

async function tryLogin(username, password) {
    const promisePool = pool.promise();
    const [rows, fields] = await promisePool.query("SELECT password FROM users WHERE username = ?", [username]);
    if (rows[0] !== undefined) {
        const match = await bcrypt.compare(password, rows[0].password);
        if (match) {
            const [rows, fields] = await promisePool.query("SELECT id, handle, username, is_admin, is_verified, image FROM users WHERE username = ?", [username]);
            return rows[0]
        } else {
            return false
        }
        
    }
}

export const authOptions = {
    // Configure one or more authentication providers
    providers: [
        // ...add more providers here
        CredentialsProvider({
            // The name to display on the sign in form (e.g. "Sign in with...")
            name: "Credentials",
            // `credentials` is used to generate a form on the sign in page.
            // You can specify which fields should be submitted, by adding keys to the `credentials` object.
            // e.g. domain, username, password, 2FA token, etc.
            // You can pass any HTML attribute to the <input> tag through the object.
            credentials: {
                username: { label: "Username", type: "text", placeholder: "ACoolUsername" },
                password: { label: "Password", type: "password" }
            },
            async authorize(credentials, req) {
                // Add logic here to look up the user from the credentials supplied
                var user = await tryLogin(credentials.username, credentials.password)
                
                if (user) {
                    user.is_admin = user.is_admin === 1 // Convert admin from int to bool
                    user.is_verified = user.is_verified === 1 // Convert verified from int to bool
                    return user
                } else {
                    return null
                }

            }
        })
    ],
    /* https://stackoverflow.com/questions/64576733/where-and-how-to-change-session-user-object-after-signing-in/64595973#64595973 */
    callbacks: {
        jwt: async ({ token, user }) => {
            user && (token.user = user)
            return {...token, ...user}
        },
        session: async ({ session, token }) => {
            session.user = token.user
            return session
        }    
    },
    pages: {
        signIn: '/login',
        newUser: '/register'
    }
}

export default NextAuth(authOptions)