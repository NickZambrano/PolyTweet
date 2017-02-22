
class SingleUser
    
{
    static func setUser(userToSet: User){
        user = userToSet
    }
    static var user : User?
    static func getUser() -> User?{
        return user;
    }
    static func destroy(){
        user=nil;
    }
}
