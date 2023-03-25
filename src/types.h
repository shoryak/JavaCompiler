#ifndef TYPES_H
#define TYPES_H

#include <string>
#include <vector>
#include <cassert>

namespace compiler::types
{
    // Primitive types
    const std::string
        c_NONE      = "",
        c_VOID      = "void",
        c_CHAR      = "char",
        c_BYTE      = "byte",
        c_SHORT     = "short",
        c_INT       = "int",
        c_LONG      = "long",
        c_FLOAT     = "float",
        c_DOUBLE    = "double",
        c_BOOLEAN   = "boolean",
        c_STRING    = "String";

    class Type
    {
        /*  Name of the individual unit's type  */
        std::string typeName_ = c_NONE;

        /*  Number of dimensions (e.g. 1 in the case of a 1-D array) */
        int numDimensions_;

        /*  So for a 2-D array of int, typeName = c_INT, numDimensions = 2  */

    public:
        /*  Constructors */
        Type(void) {}
        Type(std::string typeName): typeName_{typeName}, numDimensions_{0} {}
        Type(std::string typeName, int numDimensions)
        : typeName_{typeName}, numDimensions_{numDimensions} {}

        /*  Get type name of the current type   */
        std::string typeName(void)
        {
            return this->typeName_;
        }

        /*  Set current type to another type, without changing dimensions   */
        void setTypeName(std::string typeName)
        {
            this->typeName_ = typeName;
        }

        /*  Type of List[current type]  */
        Type listType(void)
        {
            return Type(this->typeName_, this->numDimensions_ + 1);
        }

        /*  If type is a list of some element type, return the element type */
        Type elementType(void)
        {
            assert(this->numDimensions_ > 0);
            return Type(this->typeName_, this->numDimensions_ - 1);
        }

        /*  Return printable type */
        std::string printable(void)
        {
            std::string printableType = this->typeName_;
            for(int iter = 0; iter < this->numDimensions_; iter++)
                printableType += "[]";
            return printableType;
        }
    };

    const Type
        c_NONE_TYPE(c_NONE),
        c_VOID_TYPE(c_VOID),
        c_CHAR_TYPE(c_CHAR),
        c_BYTE_TYPE(c_BYTE),
        c_SHORT_TYPE(c_SHORT),
        c_INT_TYPE(c_INT),
        c_LONG_TYPE(c_LONG),
        c_FLOAT_TYPE(c_FLOAT),
        c_DOUBLE_TYPE(c_DOUBLE),
        c_BOOLEAN_TYPE(c_BOOLEAN),
        c_STRING_TYPE(c_STRING);
    
    class FunctionType
    {
        /*  Return type of the function */
        Type returnType_ = c_NONE_TYPE;

        /*  Types of all the arguments  */
        std::vector<Type> argumentTypes_;

    public:
        /*  Constructors    */
        FunctionType(void) {}
        FunctionType(Type returnType): returnType_{returnType} {}
        FunctionType(Type returnType, std::vector<Type> argumentTypes)
        : returnType_{returnType}, argumentTypes_{argumentTypes} {}

        /*  Return type of the function */
        Type returnType(void)
        {
            return this->returnType_;
        }

        /*  Set the return type of the function */
        void setReturnType(Type returnType)
        {
            this->returnType_ = returnType;
        }

        /*  Add argument type to the function's signature   */
        void addArgumentType(Type argumentType)
        {
            this->argumentTypes_.push_back(argumentType);
        }

        /*  Return number of arguments of the function type */
        int numArguments(void)
        {
            return this->argumentTypes_.size();
        }

        /*  Return printable type   */
        std::string printable(void)
        {
            std::string printableType = returnType_.printable() + " (";
            for(auto argumentType: argumentTypes_)
            {
                printableType += argumentType.printable() + ", ";
            }
            printableType += ")";
            return printableType
        }
    };
}

#endif
