## Put comments here that give an overall description of what your
## functions do

## Write a short comment describing this function
#This function creates a special "matrix" object and cache its inverse.
makeCacheMatrix <- function(x = matrix()) {
  inv <- NULL
  
  get <- function() x
  set <- function(y) {
    x <<- y
    inv <<- NULL
  }
  
  getinverse <- function() inv
  setinverse <- function(inverse) inv <<- inverse
  
  list(get=get, set=set, getinv=getinverse, setinv=setinverse)
  
}


## Write a short comment describing this function
#This function computes the inverse of the special "matrix" returned by
#the makeCacheMatrix above. If the inverse has already been calculated
#(and the matrix has not changed), then CacheSolve should retrieve the
#inverse from the cache
cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
  inv <- x$getinverse()
  
  if (!is.null(inv)) {
    message("inverse is already cached")
    return(inv)
  }
  
  m <- x$get()
  inv <- solve(m, ...)
  
  x$setinverse(inv)
  
  return(inv)
}
